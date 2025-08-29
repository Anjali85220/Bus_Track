const express = require('express');
const router = express.Router();
const { getCoordinates } = require('../controllers/busController');

router.get('/test', (req, res) => {
  res.send("Bus route working!");
});

router.get('/location', getCoordinates); // 👈 this is needed

module.exports = router;
