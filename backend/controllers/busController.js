const axios = require('axios');

const getCoordinates = async (req, res) => {
  const address = req.query.address;

  if (!address) {
    return res.status(400).json({ error: 'Address is required' });
  }

  try {
    const response = await axios.get(
      'https://maps.googleapis.com/maps/api/geocode/json',
      {
        params: {
          address: address,
          key: process.env.GOOGLE_MAPS_API_KEY
        }
      }
    );

    const location = response.data.results[0]?.geometry?.location;

    if (!location) {
      return res.status(404).json({ error: 'Location not found' });
    }

    res.json({
      latitude: location.lat,
      longitude: location.lng
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch coordinates' });
  }
};

module.exports = { getCoordinates };
