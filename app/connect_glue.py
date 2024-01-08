import os
from dotenv import load_dotenv
import sys
from pyspark.context import SparkContext
from awsglue.utils import getResolvedOptions, GlueArgumentError
from awsglue.context import GlueContext


def init_glue():
    try:
        args = getResolvedOptions(
            sys.argv,
            [
                "JOB_NAME",
                "S3_READ_PATH",
                "S3_WRITE_PATH",
            ],
        )
        print("\nRunning Glue Online\n")
    except GlueArgumentError:
        print("\nRunning Glue Locally\n")
        load_dotenv("../.env")
        args = {"JOB_NAME": "local"}
        
    for key, value in args.items():
        os.environ[key] = value
    
    sc = SparkContext()
    glue_context = GlueContext(sc)
    spark = glue_context.spark_session

    return spark, args
