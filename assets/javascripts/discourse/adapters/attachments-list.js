import RestAdapter from "discourse/adapters/rest";

export default class AttachmentsList extends RestAdapter {
  pathFor() {
    return "admin/attachments";
  }
}
