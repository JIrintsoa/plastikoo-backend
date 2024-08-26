import swaggerJsdoc from "swagger-jsdoc";
// import swaggerUiExpress from "swagger-ui-express";


const definition = {
    openapi: '3.0.0',
    info: {
        version: '1.0.0',
        title: 'Plastikoo backend documentation',
        description: 'all details about plastikoo documentation',
    },
    servers: [
        {
            url: 'http://localhost:5000',
            description: 'Development server',
        },
    ],
};


const options = {
    definition,
    // Path to the API docs
    apis: [
        './routes/*.js',
        './routes/forum/*.js'
    ], // Adjust this to the location of your route files
};

const swaggerSpec = swaggerJsdoc(options);

export default {
    swaggerSpec
}