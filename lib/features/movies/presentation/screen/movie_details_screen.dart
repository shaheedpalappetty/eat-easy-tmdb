import 'package:eat_easy_assignment/core/utils/custom_snackbar.dart';
import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/core/widgets/custom_button.dart';
import 'package:eat_easy_assignment/features/movies/data/data_model/movie_cast.dart';
import 'package:eat_easy_assignment/features/movies/domain/entities/movie_list_entity.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/movie_details/movie_details_bloc.dart';
import 'package:eat_easy_assignment/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsScreen extends StatefulWidget {
  final ResultEntity movie;
  final String tag;
  const MovieDetailsScreen(
      {super.key, required this.tag, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool addToFavouritesLoading = false;
  bool addToWatchListLoading = false;
  @override
  void initState() {
    super.initState();
    context
        .read<MovieDetailsBloc>()
        .add(GetCastDetailsEvent(widget.movie.id ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title ?? 'Movie Title',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 8.h),
        child: SingleChildScrollView(
          // Make the whole screen scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.tag,
                child: Container(
                  width: double.infinity, // Take full width
                  height: 200.h, // Adjust the height as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 2.w, // Border width
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h), // Shadow position
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    widget.movie.backdropPath != null
                        ? "https://image.tmdb.org/t/p/w200${widget.movie.backdropPath}"
                        : 'https://via.placeholder.com/400x200.png', // Replace with the actual image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Movie Rating (Placeholder)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    (widget.movie.voteAverage != null
                            ? '${widget.movie.voteAverage!.toStringAsFixed(1)}/10'
                            : '8.5/10')
                        .toString(), // Placeholder rating
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Movie Overview (Placeholder)
              Text(
                'Overview',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.movie.overview ??
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam in venenatis enim. Sed aliquet nunc sit amet nisi blandit, non auctor tortor tincidunt. Aenean auctor dui vitae eros laoreet, ut malesuada urna dictum. Phasellus euismod felis vitae nulla dapibus, id vestibulum orci scelerisque. Integer ac maximus dui. Maecenas tincidunt ipsum vitae nulla volutpat, et pharetra erat ultricies. Curabitur varius hendrerit dui, sit amet varius ex accumsan in. Vivamus accumsan, ipsum vel bibendum tincidunt, elit sapien venenatis ipsum, id auctor lorem sapien ac risus.Sed sollicitudin nisi id leo vehicula, id congue augue ultricies. Integer sagittis augue at neque efficitur, at venenatis risus malesuada. Fusce sit amet turpis fringilla, efficitur purus sit amet, tincidunt mi. Ut sit amet magna ultricies, dignissim felis id, placerat nulla. Aliquam erat volutpat. Ut vitae velit non lectus aliquam viverra. Nulla ac ligula felis. Nam eget eros ac neque tincidunt vehicula. In vel lorem id risus euismod tincidunt. Curabitur faucibus eros eget felis elementum, eu convallis risus dictum.',
                style: TextStyle(fontSize: 14.sp),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16.h),

              // Cast Section (Placeholder)
              Text(
                'Cast',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              // Inside the Column, replace the Cast Section with this:
              BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
                listener: (context, state) {
                  if (state is MovieDetailsError) {
                    CustomSnackBar.show(
                        context: context,
                        message: state.message,
                        type: SnackBarType.error);
                  } else if (state is MovieDetailsLoaded) {
                    Logger.log("message ${state.message}");
                    if (state.message.isNotEmpty) {
                      CustomSnackBar.show(
                          context: context,
                          message: state.message,
                          type: SnackBarType.success);
                      context.read<MoviesBloc>().add(FetchMovies());
                    }
                  }
                },
                builder: (context, state) {
                  List<Cast> castList = [];
                  bool addToFavouritesLoading = false;
                  bool addToWatchListLoading = false;

                  if (state is MovieDetailsLoaded) {
                    addToFavouritesLoading = state.isAddingToFavorites;
                    addToWatchListLoading = state.isAddingToWatchList;
                    castList = state.cast.cast
                            ?.map((castEntity) => Cast(
                                  id: castEntity.id,
                                  name: castEntity.name,
                                  profilePath: castEntity.profilePath,
                                ))
                            .toList() ??
                        [];
                  }

                  return Column(
                    children: [
                      // Cast Section
                      SizedBox(
                        height: 120.h,
                        child: state is MovieDetailsError
                            ? Center(
                                child: Text(
                                  'Error fetching cast details.',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.red),
                                ),
                              )
                            : castList.isEmpty
                                ? Center(
                                    child: Text(
                                      'No cast details available.',
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  )
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: castList.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: 10.w),
                                    itemBuilder: (context, index) {
                                      final castMember = castList[index];
                                      return Column(
                                        children: [
                                          // Cast Image
                                          Container(
                                            width: 60.w,
                                            height: 60.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.r),
                                              image:
                                                  castMember.profilePath != null
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                            'https://image.tmdb.org/t/p/w200${castMember.profilePath}',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          // Cast Name
                                          Text(
                                            castMember.name ?? 'Unknown',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                      ),
                      SizedBox(height: 16.h),
                      // Buttons Section
                      Row(
                        children: [
                          CustomButton(
                            isLoading: addToFavouritesLoading,
                            buttonText: 'Add to Favorites',
                            onTap: () => context.read<MovieDetailsBloc>().add(
                                AddToFavouritesEvent(widget.movie.id ?? 0)),
                          ),
                          SizedBox(width: 0.04.sw),
                          CustomButton(
                            isLoading: addToWatchListLoading,
                            buttonText: 'Add to Watchlist',
                            onTap: () => context
                                .read<MovieDetailsBloc>()
                                .add(AddToWatchListEvent(widget.movie.id ?? 0)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
