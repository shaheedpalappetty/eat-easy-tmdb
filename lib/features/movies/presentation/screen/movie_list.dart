import 'package:eat_easy_assignment/core/utils/imports.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie List',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Make entire screen scrollable
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HorizontalList(title: "Favourites"),
              SizedBox(height: 16.h),

              // Watchlist Movies Section (Placeholder)
              const MoviesList(title: 'Movies List'),
              SizedBox(height: 16.h),
              const HorizontalList(title: "WatchList"),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
