import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:shimmer/shimmer.dart';

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
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 150.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: isLoading ? 5 : movies.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              if (isLoading) {
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
              }

              final movie = movies[index];
              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsScreen(
                      movie: movies[index],
                      tag: movie.id.toString(),
                    ),
                  ),
                ),
                child: Hero(
                  tag: "${title}_${movie.id}",
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                      image: movie.posterPath != null
                          ? DecorationImage(
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: movie.posterPath == null
                        ? Center(
                            child: Text(
                              movie.title ?? 'No Title',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
