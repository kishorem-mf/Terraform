import sys
import logging
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

try:
    # Your existing code here

    inputDF = glueContext.create_dynamic_frame_from_options(connection_type="s3",
                                                            connection_options={"paths": ["s3://awsglue-datasets/examples/us-legislators/all/memberships.json"]}, format="json")

    inputDF.show(5)
    
    # Converting to pandas dataframe
    df = inputDF.toDF()
    df_pd = df.toPandas()

    logger.info('Test script has successfully run')

except Exception as e:
    # Log any exceptions
    logger.error(f'An error occurred: {str(e)}', exc_info=True)
    sys.exit(1)
