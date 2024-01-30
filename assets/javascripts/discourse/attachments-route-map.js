export default function () {
  this.route("admin", { resetNamespace: true }, function () {
    this.route(
      "adminAttachments",
      { path: "/attachments", resetNamespace: true }
    );
  })
}
