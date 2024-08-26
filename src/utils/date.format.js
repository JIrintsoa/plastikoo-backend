const backendToDB = (arg) => {
    return arg.toISOString().replace('T', ' ').replace('Z', '').trim()
}

const datePatterns = [
    /^\d{4}-\d{2}-\d{2}$/, // yyyy-mm-dd
    /^\d{4}\/\d{2}\/\d{2}$/ // yyyy/mm/dd
];

// Function to check if the date string matches any valid pattern
const isValidDateFormat = (dateStr) => datePatterns.some(pattern => pattern.test(dateStr));

// Function to parse date string into a Date object
const parseDate = (dateStr) => {
    const [year, month, day] = dateStr.split(/[-/]/).map(Number);
    return new Date(year, month - 1, day);
};



export default {
    backendToDB,
    isValidDateFormat,
    parseDate
}