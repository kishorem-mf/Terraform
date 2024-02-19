import sys
import logging
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext

# Initialize the Spark and Glue contexts
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Get job arguments
args = getResolvedOptions(sys.argv, ['s3_bucket', 's3_filepath'])

# S3 bucket and file path
s3_bucket = args['s3_bucket']
s3_filepath = args['s3_filepath']

# Full S3 URI
s3_uri = f"s3://{s3_bucket}/{s3_filepath}"

try:
    # Log job start
    logger.info("Job started with arguments:")
    logger.info(f"S3_BUCKET: {s3_bucket}")
    logger.info(f"S3_FILEPATH: {s3_filepath}")

    # Read CSV file from S3 into a DataFrame
    df = spark.read.option("header", "true").csv(s3_uri)

    # Display the first 5 records
    df.show(5)

    # Your further processing logic can be added here

    # Log job success
    logger.info("Job completed successfully!")

except Exception as e:
    # Log the exception
    logger.error(f"An error occurred: {str(e)}")
    raise e
