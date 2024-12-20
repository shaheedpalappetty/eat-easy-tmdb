import 'package:eat_easy_assignment/core/utils/imports.dart';

class MoviesList extends StatefulWidget {
  final String title;
  final List<ResultEntity> movies;
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final bool isLoading;

  const MoviesList({
    super.key,
    required this.title,
    required this.movies,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.isLoading,
  });

  @override
  State<MoviesList> createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        SizedBox(height: 8.h),
        _buildMovieList(context),
        SizedBox(height: 16.h),
        _buildPaginationWidget(context),
        if (widget.movies.isEmpty && !widget.isLoading)
          _buildEmptyState(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      widget.title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildMovieList(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    } else if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          return _buildMovieItem(movie, context);
        },
      );
    }
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 100.w,
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieItem(ResultEntity movie, BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsScreen(
            movie: movie,
            tag: movie.id.toString(),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            _buildMoviePoster(movie, context),
            SizedBox(width: 12.w),
            _buildMovieInfo(movie, context),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviePoster(ResultEntity movie, BuildContext context) {
    return Hero(
      tag: 'MovieList_${movie.id}',
      child: Container(
        width: 80.w,
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: movie.posterPath != null
              ? DecorationImage(
                  image: NetworkImage(
                    '${NetworkRoutes.imageUrl}${movie.posterPath}',
                  ),
                  fit: BoxFit.cover,
                )
              : null,
          color: movie.posterPath == null ? Colors.grey[800] : null,
        ),
        child: movie.posterPath == null
            ? Icon(
                Icons.movie,
                size: 30.sp,
                color: Colors.grey[400],
              )
            : null,
      ),
    );
  }

  Widget _buildMovieInfo(ResultEntity movie, BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title ?? 'No Title',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            movie.overview ?? 'No description available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[400],
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          _buildMovieMetadata(movie, context),
        ],
      ),
    );
  }

  Widget _buildMovieMetadata(ResultEntity movie, BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star_rounded,
          color: Colors.amber,
          size: 20.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          (movie.voteAverage ?? 0).toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(width: 16.w),
        Icon(
          Icons.calendar_today_rounded,
          size: 18.sp,
          color: Colors.grey[400],
        ),
        SizedBox(width: 4.w),
        Text(
          movie.releaseDate?.year.toString() ?? 'N/A',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[400],
              ),
        ),
        SizedBox(width: 16.w),
        if (movie.adult == true) _buildAdultContentIndicator(context),
      ],
    );
  }

  Widget _buildAdultContentIndicator(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        '18+',
        style: TextStyle(
          color: Colors.red,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaginationWidget(BuildContext context) {
    return PaginationWidget(
      currentPage: widget.currentPage,
      totalPages: widget.totalPages,
      onPageChanged: widget.onPageChanged,
      maxVisiblePages: 50,
      context: context,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          children: [
            Icon(
              Icons.movie,
              size: 48.sp,
              color: Colors.grey[600],
            ),
            SizedBox(height: 16.h),
            Text(
              'No movies found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
