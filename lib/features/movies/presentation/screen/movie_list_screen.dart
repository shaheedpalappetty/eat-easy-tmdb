import 'package:eat_easy_assignment/core/utils/imports.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  bool isLoading = false;
  int currentPage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MoviesBloc>().add(FetchMovies());
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: BlocConsumer<MoviesBloc, MoviesState>(
              listener: (context, state) {
                if (state is MoviesInitial || state is MoviesLoading) {
                  isLoading = true;
                } else if (state is MoviesError) {
                  CustomSnackBar.show(
                      context: context,
                      message: state.message,
                      type: SnackBarType.error);
                  isLoading = false;
                } else if (state is MoviesLoaded) {
                  isLoading = false;
                }
              },
              builder: (context, state) {
                if (state is MoviesLoading || state is MoviesInitial) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HorizontalList(
                        title: 'Favourites',
                        movies: [],
                        isLoading: true,
                      ),
                      SizedBox(height: 16.h),
                      MoviesList(
                        title: 'Movies List',
                        movies: [],
                        currentPage: 0,
                        totalPages: 0,
                        onPageChanged: (page) {},
                        isLoading: isLoading,
                      ),
                      SizedBox(height: 16.h),
                      const HorizontalList(
                        title: 'WatchList',
                        movies: [],
                        isLoading: true,
                      ),
                    ],
                  );
                }
                if (state is MoviesError) {
                  return Center(child: Text(state.message));
                }

                if (state is MoviesLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HorizontalList(
                        title: "Favourites",
                        movies: state.favoriteMovies?.results ?? [],
                        isLoading: isLoading,
                      ),
                      SizedBox(height: 16.h),
                      MoviesList(
                        isLoading: isLoading,
                        title: 'Movies List',
                        movies: state.movies.results ?? [],
                        currentPage: currentPage,
                        totalPages: 50,
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                          context
                              .read<MoviesBloc>()
                              .add(LoadSpecificPage(page));
                        },
                      ),
                      SizedBox(height: 16.h),
                      HorizontalList(
                        title: "WatchList",
                        movies: state.watchlistMovies?.results ?? [],
                      ),
                      SizedBox(height: 8.h),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
