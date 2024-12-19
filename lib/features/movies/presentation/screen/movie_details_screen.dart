import 'package:eat_easy_assignment/core/utils/imports.dart';
import 'package:eat_easy_assignment/core/widgets/custom_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String index;
  const MovieDetailsScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Title', // Replace with dynamic title
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
              // Title Image with Border Decoration
              Hero(
                tag: index,
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
                    'https://via.placeholder.com/400x200.png', // Replace with the actual image URL
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
                    '8.5/10', // Placeholder rating
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
              SizedBox(
                height: 120.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Placeholder for number of cast members
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        // Cast Image (Placeholder)
                        Container(
                          width: 60.w,
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Cast Name (Placeholder)
                        Text(
                          'Actor $index', // Placeholder actor name
                          style: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),

              // Buttons for Add to Favorites and Add to Watchlist
              Row(
                children: [
                  CustomButton(
                    buttonText: 'Add to Favorites',
                    onTap: () {},
                  ),
                  SizedBox(width: 0.04.sw),
                  CustomButton(
                    buttonText: 'Add to Watchlist',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
