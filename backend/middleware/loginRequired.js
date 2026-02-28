import jwt from "jsonwebtoken";

/**
 * JWT шалгаад req.userId тохируулна
 * Authorization: Bearer <token> шаардлагатай
 */
const loginRequired = (req, res, next) => {
  const authHeader = req.headers.authorization;
  const token = authHeader?.startsWith("Bearer ") ? authHeader.slice(7) : null;

  if (!token) {
    throw req.sendError("ERR_007");
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch {
    throw req.sendError("ERR_007");
  }
};

export default loginRequired;
