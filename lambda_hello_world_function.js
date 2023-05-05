exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    headers: { 'Content-Type': 'text/html' },
    body: '<h1>Hello, World! testing lambda versioning after setting publish to true</h1>',
  };
  return response;
};