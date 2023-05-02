exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    headers: { 'Content-Type': 'text/html' },
    body: '<h1>Hello, World! test: triggering workflow when js files changes</h1>',
  };
  return response;
};