const backendToDB = (arg) => {
    return arg.toISOString().replace('T', ' ').replace('Z', '').trim()
}

export default {
    backendToDB
}