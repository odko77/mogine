const errors = {
    ERR_001:    {
                    code: 1,
                    name: "ERROR 001",
                    message: 'Алдаа гарсан байна',
                    statusCode: 400,
                },
    ERR_002:    {
                    code: 2,
                    name: "ERROR 002",
                    message: 'Бүртгэлтэй {0} байна',
                    statusCode: 400,
                },
    ERR_003:    {
                    code: 3,
                    name: "ERROR 003",
                    message: 'Илэрц олдсонгүй тул дахин оролдно уу',
                    statusCode: 404,
                },
    ERR_004:    {
                    code: 4,
                    name: "ERROR 004",
                    message: 'Алдаа гарсан тул админд мэдэгдэнэ үү.',
                    statusCode: 500,
                },
    ERR_005:    {
                    code: 5,
                    name: "ERROR 005",
                    message: '{0} оруулна уу',
                    statusCode: 400,
                },
    ERR_006:    {
                    code: 6,
                    name: "ERROR 006",
                    message: 'Таны оруулсан код буруу байна',
                    statusCode: 400,
                },
    ERR_007:    {
                    code: 7,
                    name: "ERROR 007",
                    message: 'Нэвтрэх эрх шаардлагатай',
                    statusCode: 401,
                },
}

export default errors;
