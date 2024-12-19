import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
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
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesInitial || state is MoviesLoading) {
                  return const Center(child: CircularProgressIndicator());
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
                        movies: state.movies.results ?? [],
                      ),
                      SizedBox(height: 16.h),
                      MoviesList(
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
                        movies: state.movies.results ?? [],
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
