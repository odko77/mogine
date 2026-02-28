import { Stringformat } from '../index.js'
import errors from './errors/index.js'

class CError extends Error
{
    /**
     * throw Алдааны msg ийг rsp буцаах
     * @param {string} errorCode алдааны дугаар
     * @param  {...any} errorArgs алдааны msg нь -д argument оноох нь
     */
    constructor(errorCode, ...errorArgs)
    {
        super(errorCode)

        //  алдааны мессеж дунд argument ыг олох
        //  RESPONSE_MULTIPLE_SYMBOL текст дотор уг sign тай тэмдэг байвал
        //  split хийж оноох
        if (errorCode.includes(process.env.RESPONSE_MULTIPLE_SYMBOL))
        {
            const splited = errorCode.split(process.env.RESPONSE_MULTIPLE_SYMBOL)
            errorCode = splited[0]
            errorArgs = splited.slice(1, splited.length)
        }

        this.error = errors[errorCode]
        this.error = this.error ? this.error : errors['ERR_004']

        /** Серверийн дээр алдаа гарсан байвал client руу ERR_004 error ийг дамжуулж server дээр алдааг хэвлэх тул message руу алдааг оноох нь */
        this.message = this.error.statusCode < 500 ? Stringformat(this.error.message, ...errorArgs) : errorCode
        this.statusCode = this.error.statusCode

        this.rsp =  {
            code: this.error.code,
            name: this.error.name,
            message: this.error.statusCode < 500 ? this.message : this.error.message,
        }
    }
}

export default CError
