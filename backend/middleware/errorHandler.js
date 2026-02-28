import colors from 'cli-color'
import errors from '../utils/rsp/errors/index.js'

/**
 * controller дотроос throw хийсэн алдааны
 * msg ийг барьж аван response буцаах нь
 */
const errorHandler = (err, req, res, next) =>
{
    let rspError = err.rsp
    if (!err?.rsp) {
        rspError = errors["ERR_004"]
        rspError["og"] = err?.stack
    }

    //  дотоодын алдаа үеийг л хэвлэх
    if (err.statusCode >= 500 || !err?.rsp)
    {
        //  Алдааны мэдэгдлийг server дээр хэвлэх нь (улаан өнгөтэй харуулдаг болсон)
        console.log(colors.red(err.stack));
    }

    res.status(err.statusCode || 500).json(
        {
            success: false,
            data: "",
            error: rspError,
        }
    )
}

export default errorHandler
