import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:photo_gallery/core/failures.dart';
import 'package:photo_gallery/features/domain/photo_entity.dart';
import 'package:photo_gallery/features/ui/bloc/photo_bloc.dart';
import 'package:photo_gallery/features/ui/bloc/photo_event.dart';
import 'package:photo_gallery/features/ui/bloc/photo_state.dart';
import 'package:photo_gallery/features/ui/screens/photo_screen.dart';
import 'package:bloc_test/bloc_test.dart';

class MockPhotoBloc extends Mock implements PhotoBloc {
  @override
  Stream<PhotoState> get stream => Stream.empty();
}

void main() {
  late MockPhotoBloc mockPhotoBloc;

  setUp(() {
    mockPhotoBloc = MockPhotoBloc();
  });

  Widget createTestWidget() {
    return MaterialApp(
      home: BlocProvider<PhotoBloc>.value(
        value: mockPhotoBloc,
        child: const PhotoScreen(),
      ),
    );
  }

  testWidgets('Показывает CircularProgressIndicator при PhotoLoading', (WidgetTester tester) async {
    when(() => mockPhotoBloc.state).thenReturn(PhotoLoading());

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Показывает список фото при PhotoLoaded', (WidgetTester tester) async {
    final photos = [
      PhotoEntity(
        id: 1,
        title: 'accusamus beatae ad facilis cum similique qui sunt',
        url: 'https://via.placeholder.com/600/92c952',
        thumbnailUrl: 'https://via.placeholder.com/150/92c952',
      ),
    ];
    when(() => mockPhotoBloc.state).thenReturn(PhotoLoaded(photos));

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('accusamus beatae ad facilis cum similique qui sunt'), findsOneWidget);
  });

  testWidgets('Показывает сообщение об ошибке при PhotoError', (WidgetTester tester) async {
    when(() => mockPhotoBloc.state).thenReturn(PhotoError(ServerFailure('Ошибка загрузки')));

    await tester.pumpWidget(createTestWidget());

    expect(find.text('Ошибка загрузки'), findsOneWidget);
  });

  testWidgets('Вызывает FetchPhotos при нажатии на кнопку fetch', (WidgetTester tester) async {
    whenListen(mockPhotoBloc, Stream.value(PhotoLoaded([])));
    when(() => mockPhotoBloc.state).thenReturn(PhotoLoaded([]));

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('fetch'));
    await tester.pump();

    verify(() => mockPhotoBloc.add(FetchPhotos())).called(1);
  });

  testWidgets('Вызывает GetSavedPhotos при нажатии на кнопку get cache', (WidgetTester tester) async {
    whenListen(mockPhotoBloc, Stream.value(PhotoLoaded([])));
    when(() => mockPhotoBloc.state).thenReturn(PhotoLoaded([]));

    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.text('get cache'));
    await tester.pump();

    verify(() => mockPhotoBloc.add(GetSavedPhotos())).called(1);
  });

  testWidgets('Показывает SnackBar при оффлайн-режиме', (WidgetTester tester) async {
    whenListen(mockPhotoBloc, Stream.value(PhotoLoaded([])));
    when(() => mockPhotoBloc.state).thenReturn(PhotoLoaded([]));

    await tester.pumpWidget(createTestWidget());

    await tester.runAsync(() async {
      final state = tester.state(find.byType(PhotoScreen)) as dynamic;
      await state._checkInternetAndFetchPhotos();
    });

    await tester.pumpAndSettle();

    expect(find.text('Вы в оффлайн-режиме'), findsOneWidget);
  });
}
