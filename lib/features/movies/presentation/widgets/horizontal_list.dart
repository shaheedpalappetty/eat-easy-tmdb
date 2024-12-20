import 'package:eat_easy_assignment/core/utils/imports.dart';

class HorizontalList extends StatelessWidget {
  final String title;
  final List<ResultEntity> movies;
  final bool isLoading;

  const HorizontalList({
    super.key,
    required this.title,
    required this.movies,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        SizedBox(height: 8.h),
        _buildMovieList(context),
      ],
    );
  }

  // Build the title section
  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  // Build the movie list section
  Widget _buildMovieList(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: isLoading
          ? _buildShimmerLoading()
          : movies.isEmpty
              ? _buildNoMoviesText(context)
              : _buildMovieListView(context),
    );
  }

  // Build the shimmer loading effect
  Widget _buildShimmerLoading() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(width: 10.w),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: _buildShimmerContainer(),
        );
      },
    );
  }

  // Shimmer container for loading state
  Widget _buildShimmerContainer() {
    return Container(
      width: 100.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }

  // Build the 'No Movies' text
  Widget _buildNoMoviesText(BuildContext context) {
    return Center(
      child: Text(
        'No Favourite Movies',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  // Build the list view of movies
  Widget _buildMovieListView(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      separatorBuilder: (_, __) => SizedBox(width: 10.w),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieItem(context, movie);
      },
    );
  }

  // Build a single movie item
  Widget _buildMovieItem(BuildContext context, ResultEntity movie) {
    return InkWell(
      onTap: () => _navigateToMovieDetailsScreen(context, movie),
      child: Hero(
        tag: "${title}_${movie.id}",
        child: _buildMovieCard(movie, context),
      ),
    );
  }

  // Navigate to the MovieDetailsScreen
  void _navigateToMovieDetailsScreen(BuildContext context, ResultEntity movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(
          movie: movie,
          tag: movie.id.toString(),
        ),
      ),
    );
  }

  // Build the movie card widget
  Widget _buildMovieCard(ResultEntity movie, BuildContext context) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
        image: movie.posterPath != null
            ? DecorationImage(
                image: NetworkImage(
                  '${NetworkRoutes.imageUrl}${movie.posterPath}',
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: movie.posterPath == null ? _buildMovieTitle(movie, context) : null,
    );
  }

  // Build the movie title when there is no poster image
  Widget _buildMovieTitle(ResultEntity movie, BuildContext context) {
    return Center(
      child: Text(
        movie.title ?? 'No Title',
        style: Theme.of(context).textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
