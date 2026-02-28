/**
 * Controller бүр дээр try catch ашиглахгүй гээр
 * middleware дээр нь trycatch тавих нь
 * @param {Function} func controller байна
 */
const asyncHandler = (func) => (req, res, next) => {
    Promise
        .resolve(func(req, res, next))
        .catch((err) => {
            next(err)
        })
}

export default asyncHandler
