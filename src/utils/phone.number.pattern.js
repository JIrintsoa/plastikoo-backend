// Define the Malagasy phone number pattern as a constant
const malagasyPhoneNumberPattern = /^\+(?:261|3[2348])\d{8}$/;

const phoneNumberPattern = {
    malagasy: /^\+(?:261|3[2348])\d{9}$/
}

// Reusable function for validating Malagasy phone numbers
const validateMalagasyPhoneNumber = (value) => {
    console.log(value)
    if (!phoneNumberPattern.malagasy.test(value)) {
        throw new Error("Invalid Malagasy phone number format");
        // res.json({error:"Invalid Malagasy phone number format"})
    }
    return value;
};

export default {
    validateMalagasyPhoneNumber
}