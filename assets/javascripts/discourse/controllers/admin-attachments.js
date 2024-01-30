import Controller from "@ember/controller";
import { inject as service } from "@ember/service";
import { action } from "@ember/object";
import discourseComputed from "discourse-common/utils/decorators";
import { observes } from "@ember-decorators/object";
import discourseDebounce from "discourse-common/lib/debounce";
import Attachment from "../models/attachment"
import { INPUT_DELAY } from "discourse-common/config/environment";
import { i18n } from "discourse/lib/computed";

export default class AdminAttachmentsController extends Controller {
  @service router;
  listFilter = null;

  model = null;
  query = null;
  order = null;
  asc = null;
  showEmails = false;
  refreshing = false;
  listFilter = null;
  selectAll = false;

  _page = 1;
  _results = [];
  _canLoadMore = true;

  @i18n("admin.uploads.search_hint") searchHint;

  @observes("listFilter")
  _filterUsers() {
    discourseDebounce(this, this.resetFilters, INPUT_DELAY);
  }

  resetFilters() {
    this._page = 1;
    this._results = [];
    this._canLoadMore = true;
    this._refreshUploads();
  }

  _refreshUploads() {
    if (!this._canLoadMore) {
      return;
    }

    const page = this._page;
    this.set("refreshing", true);

    Attachment.findAll({
      filter: this.listFilter,
      order: this.order,
      asc: this.asc,
      page,
    })
      .then((result) => {
        this._results[page] = result;
        this.set("model", this._results.flat());

        if (result.length === 0) {
          this._canLoadMore = false;
        }
      })
      .finally(() => {
        this.set("refreshing", false);
      });
  }

  @action
  loadMore() {
    this._page += 1;
    this._refreshUploads();
  }


  @discourseComputed
  columnCount() {
    let colCount = 5; // note that the first column is hardcoded in the template

    return colCount;
  }
}
