import 'package:eat_easy_assignment/core/utils/imports.dart';

class MoviesList extends StatelessWidget {
  final String title;
  const MoviesList({super.key, required this.title});

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
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          // Remove Expanded to make it scrollable
          shrinkWrap: true, // Ensure ListView doesn't take up unnecessary space
          itemCount: 10, // Replace with actual data count
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsScreen(
                      index: 'MovieList$index',
                    ),
                  )),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    // Movie Poster Placeholder
                    Hero(
                      tag: 'MovieList$index',
                      child: Container(
                        width: 50.w,
                        height: 75.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Movie Info Placeholder
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Movie Title $index',
                              style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(height: 5.h),
                          Text(
                            'This is a placeholder description for movie $index. Replace with actual data.',
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
