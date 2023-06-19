
data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "/tmp/lambda_${local.function_name}_inline.zip"
  source {
    content  = <<EOF
exports.handler = async (event, context) => {
  // THIS is generally a wrong approach and should be replaced with some AWS constructs
  // Perform some initial work that satisfies the API Gateway response time requirements
  const result = await doInitialWork();

  // Continue with additional work after a 1 second delay
  setTimeout(async () => {
    try {
      await doAdditionalWork();
      console.log('Additional work completed');
    } catch (error) {
      console.error('Error during additional work:', error);
    }
  }, 1000);

  // Return a response to the API Gateway
  return {
    statusCode: 200,
    body: result + '; your request has been recived, working on it #' + context.awsRequestId 
  };
};

async function doInitialWork() {
  // Perform some work that satisfies the API Gateway response time requirements
  return 'Initial validation completed';
}

async function doAdditionalWork() {
  // Perform some additional work that takes more than 2 minutes
  console.log('Continuing with additional work');
  for(let i = 0; i < 3; i++)
  {
     setTimeout( () => {
      try { 
        let remaining_time = context.get_remaining_time_in_millis();
        console.log('doing additional work ...', i, ' remaining time: ', remaining_time/1000);
      } catch (error) {
        console.error('Error during additional work:', error);
      }
    }, i * 100);
  }
}
EOF
    filename = "index.js"
  }
}