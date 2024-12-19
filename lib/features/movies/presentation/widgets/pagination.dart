import 'package:eat_easy_assignment/core/utils/imports.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final int maxVisiblePages;
  final BuildContext context;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxVisiblePages = 5,
    required this.context,
  });

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];

    // Always show first page
    buttons.add(_buildPageButton(1));

    // Calculate range of pages to show
    int startPage = currentPage - (maxVisiblePages ~/ 2);
    int endPage = currentPage + (maxVisiblePages ~/ 2);

    // Adjust range if it goes out of bounds
    if (startPage <= 1) {
      endPage = maxVisiblePages;
      startPage = 2;
    }
    if (endPage >= totalPages) {
      startPage = totalPages - maxVisiblePages + 1;
      endPage = totalPages - 1;
    }

    // Add ellipsis if there's a gap after first page
    if (startPage > 2) {
      buttons.add(_buildEllipsis());
    }

    // Add middle pages
    for (int i = startPage; i <= endPage; i++) {
      if (i > 1 && i < totalPages) {
        buttons.add(_buildPageButton(i));
      }
    }

    // Add ellipsis if there's a gap before last page
    if (endPage < totalPages - 1) {
      buttons.add(_buildEllipsis());
    }

    // Always show last page if there are more pages
    if (totalPages > 1) {
      buttons.add(_buildPageButton(totalPages));
    }

    return buttons;
  }

  Widget _buildPageButton(int page) {
    final isSelected = page == currentPage;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            onPageChanged(page);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        '...',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous page button
          if (currentPage > 1)
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onPageChanged(currentPage - 1),
            ),

          ..._buildPageButtons(),

          // Next page button
          if (currentPage < totalPages)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onPageChanged(currentPage + 1),
            ),
        ],
      ),
    );
  }
}
