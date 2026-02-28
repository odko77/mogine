/**
 * String дотор {0} дотор argument -д байгаа утгыг оноох нь
 * @param {string} string Үндсэн үг
 * @returns зассан үг
 */
export const Stringformat = function(string)
{
    var args = Array.prototype.slice.call(arguments, 1, arguments.length);
    return string.replace(/{(\d+)}/g, function (match, number) {
        return typeof args[number] != "undefined" ? args[number] : match;
    });
};
