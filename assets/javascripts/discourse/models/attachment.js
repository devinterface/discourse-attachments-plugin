import { ajax } from "discourse/lib/ajax";

export default class Upload {
  static findAll(userFilter) {
    return ajax(`/admin/attachments.json`, {
      data: userFilter,
    }).then((uploads) => uploads);
  }
}
