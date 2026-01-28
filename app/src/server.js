const express = require("express");

const app = express();
const port = process.env.PORT || 8080;

app.get("/", (req, res) => {
  res.json({
    app: "openshift-helm-nodejs",
    status: "running",
    version: process.env.APP_VERSION || "dev"
  });
});

app.get("/healthz", (req, res) => {
  res.status(200).send("ok");
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Listening on ${port}`);
});
