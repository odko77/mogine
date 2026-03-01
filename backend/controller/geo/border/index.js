import asyncHandler from "../../../middleware/asyncHandler.js";
import PointName from "../../../models/PointName.js";

/**
 * Create
 * POST /pointName
 * body: { user, name, location: { lon, lat }, icon_name, icon_color }
 */
export const createPoint = asyncHandler(async (req, res) => {
  const { name, location, icon_name, icon_color } = req.body;

  const user = req.userId
  const point = await PointName.create({
    user,
    name,
    location: { type: "Point", coordinates: [location.lon, location.lat] },
    icon_name,
    icon_color,
  });

  return req.sendData(point)
});

/**
 * Read all for user
 * GET /pointName/:userId
 */
export const readPoints = asyncHandler(async (req, res) => {
  const points = await PointName.find({ user: req.userId });
  return req.sendData(points);
})

/**
 * Read single
 * GET /pointName/detail/:id
 */
export const readPoint = asyncHandler(async (req, res) => {
  const point = await PointName.findById(req.params.id);
  if (!point) return res.status(404).json({ success: false, error: "Not found" });
  return req.sendData(point);
})

/**
 * Update
 * PUT /pointName/:id
 * body: { name?, location?, icon_name?, icon_color? }
 */
export const updatePoint = asyncHandler(async (req, res) => {
  const updateData = { ...req.body };

  if (updateData.location) {
    updateData.location = {
      type: "Point",
      coordinates: [updateData.location.lon, updateData.location.lat],
    };
  }

  const point = await PointName.findByIdAndUpdate(req.params.id, updateData, { new: true });
  if (!point) return res.status(404).json({ success: false, error: "Not found" });

  return req.sendData(point);
})

/**
 * Delete
 * DELETE /pointName/:id
 */
export const deletePoint = asyncHandler(async (req, res) => {
  const point = await PointName.findByIdAndDelete(req.params.id);
  if (!point) return res.status(404).json({ success: false, error: "Not found" });

  return req.sendData(point);
})
