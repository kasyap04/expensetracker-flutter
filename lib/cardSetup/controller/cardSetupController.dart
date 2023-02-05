import '../model/setupCardModel.dart';
import '../../trackexpenses/model/database.dart';

Future<bool> setInitialCards(bool debit, bool credit) async {
  try {
    if (debit) {
      final debitId = await SetupCardModel.addCard("debit");
    }

    if (credit) {
      final creditId = await SetupCardModel.addCard("credit");
    }
    return true;
  } catch (e) {
    return false;
  }
}
