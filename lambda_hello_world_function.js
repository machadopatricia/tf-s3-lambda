exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    headers: { 'Content-Type': 'text/html' },
    body: '<h1>Hello, World! Upload new version of Lambda Function using Github Actions.</h1>',
  };
  return response;
};