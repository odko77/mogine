import info from '../utils/rsp/info/index.js'
import warnings from '../utils/rsp/warning/index.js'
import { Stringformat } from '../utils/index.js'
import CError from '../utils/rsp/index.js'

const successFn = (req, res, next) => {

    /**
     * Амжилттай болсон мэдээлэл буцаах
     * @param {string} infoCode амжилттай болсон мэдээллийн code
     * @returns response буцаана
     */
    function sendInfo(infoCode, ...args)
    {
        const _info = info[infoCode]
        return res.status(_info.statusCode).json(
            {
                success: true,
                info: {
                    code: _info.code,
                    name: _info.name,
                    message: Stringformat(_info.message, args)
                },
                error: {}
            }
        )
    }

    /**
     * Амжилттай ажилласаны дараах data -г буцаах нь
     * @param {any} data тухайн service ээс хамаарч юу ч байж болно
     * @param {number} statusCode status code
     * @returns response буцаана
     */
    function sendData(data, statusCode=200) {
        return res.status(statusCode).json(
            {
                success: true,
                data: data,
                error: {}
            }
        )
    }

    /**
     * Амжилттай ажилласаны дараах data болон info буцаах нь
     * @param {any} data тухайн service ээс хамаарч юу ч байж болно
     * @param {number} statusCode status code
     * @returns response буцаана
     */
    function sendDataInfo(infoCode, data, ...args) {
        const _info = info[infoCode]
        return res.status(_info.statusCode).json(
            {
                success: true,
                info: {
                    code: _info.code,
                    name: _info.name,
                    message: Stringformat(_info.message, args)
                },
                data: data,
                error: {}
            }
        )
    }

    function sendError(code, ...args) {
        return new CError(code, ...args)
    }

    /**
     *  Анхааруулга буцаах бол
     * @param {string} code анхааруулгын code
     * @returns response буцаана
     */
    function sendWarning(code, ...args)
    {
        const warning = warnings[code]
        warning['message'] = Stringformat(warning.message, args)
        return res.status(warning.statusCode).json(
            {
                success: false,
                warning: warning,
            }
        )
    }

    req.sendInfo = sendInfo
    req.sendData = sendData
    req.sendDataInfo = sendDataInfo
    req.sendError = sendError
    req.sendWarning = sendWarning
    next()
}

export default successFn
