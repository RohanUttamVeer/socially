<!-- ============================================================== -->

> every time state is built appbar will be build again and again 
code :
return Scaffold(
      appBar: UiConstants.appBar(),
    );
> optimizing this, we restrict rebuilding of appbar
code :
final appBar = UiConstants.appBar();

<!-- ============================================================== -->

