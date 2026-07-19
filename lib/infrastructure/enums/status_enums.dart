enum PageStatus { initial, loading, success, error }

enum SelectListStatus { initial, loading, success, error }

extension PageStatusX on PageStatus {
  bool get isInitial => this == PageStatus.initial;

  bool get isLoading => this == PageStatus.loading;

  bool get isSuccess => this == PageStatus.success;

  bool get isError => this == PageStatus.error;
}

extension SelectListStatusX on SelectListStatus {
  bool get isInitial => this == SelectListStatus.initial;

  bool get isLoading => this == SelectListStatus.loading;

  bool get isSuccess => this == SelectListStatus.success;

  bool get isError => this == SelectListStatus.error;
}
