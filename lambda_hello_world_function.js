exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    headers: { 'Content-Type': 'text/html' },
    body: '<h1>Hello, World! test 11: zipping file when it changes</h1>',
  };
  return response;
};