
data "archive_file" "lambda_zip_inline" {
  type        = "zip"
  output_path = "/tmp/lambda_${local.function_name}_inline.zip"
  source {
    content  = <<EOF
exports.handler = async (event, context, callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    
    var res ={
        "statusCode": 200,
        "headers": {
            "Content-Type": "*/*"
        }
    };
     
    let msg = "didn't get what you are trying to say, I'm expecting a path parameter called 'proxy'";
    if (event?.pathParameters?.proxy ?? false) {
      msg = event.pathParameters.proxy;
    } 
    
    res.body = "Hello, " + msg + "!";
    return res;
};
EOF
    filename = "index.js"
  }
}