part of 'search_response_bloc.dart';

sealed class SearchResponseEvent extends Equatable {
  final BaseProvider provider;
  final String? query;

  final List<SearchResponseEntity>? responses;
  // const ProviderSearchParams({});
  const SearchResponseEvent(
      {this.responses, this.query, required this.provider});

  @override
  List<Object> get props => [provider, responses!];
}

final class SearchResponseSearch extends SearchResponseEvent {
  const SearchResponseSearch(
      {required super.provider, super.query});
}
