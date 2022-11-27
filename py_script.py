import pandas as pd 
import os
import toml
import boto3
from dotenv import load_dotenv
from sqlalchemy import create_engine

def mysql_connect(host, user, password, database, port, schema):
    engine = create_engine(f'mysql+mysqlconnector://{user}:{password}@{database}.{host}:{port}/{schema}')
    return engine

app_config = toml.load('config.toml')

host = app_config['rds']['host']
port = app_config['rds']['port']
database = app_config['rds']['db_name']
schema = app_config['rds']['schema']

bucket = app_config['s3']['bucket']
folder = app_config['s3']['folder']

load_dotenv()

user = os.getenv('user')
password = os.getenv('password')

access_key = os.getenv('access_key')
secret_access_key = os.getenv('secret_access_key')

sql="""
SELECT CustomerID, ROUND(SUM(sales), 2) FROM orders
GROUP BY CustomerID
ORDER BY ROUND(SUM(sales), 2) DESC
LIMIT 10;
"""

print('Connecting to MySQL Database')

engine = mysql_connect(host, user, password, database, port, schema)

df = pd.read_sql(sql, con = engine)
df[["CustomerID"]].head()
df[["CustomerID"]].to_json('cus_id.json')

print('Uploading file to S3 bucket')

s3 = boto3.client('s3', aws_access_key_id=access_key, aws_secret_access_key=secret_access_key)
s3.upload_file('cus_id.json', bucket, folder+'cus_id.json')