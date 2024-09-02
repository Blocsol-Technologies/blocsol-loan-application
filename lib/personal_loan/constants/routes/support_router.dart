import 'package:blocsol_loan_application/personal_loan/screens/user_screens/support/raise_ticket.dart';
import 'package:blocsol_loan_application/personal_loan/screens/user_screens/support/single_ticket_details.dart';
import 'package:go_router/go_router.dart';

class PersonalLoanSupportRouter {
  static const String raise_new_ticket =
      "/personal-credit/support/raise-new-ticket";

  static const String support_ticket_details =
      "/personal-credit/support/ticket-details";
}

List<GoRoute> personalLoanSupportRoutes = [
    GoRoute(
    path: PersonalLoanSupportRouter.support_ticket_details,
    builder: (context, state) => const PCSingleTicketDetails(),
  ),

   GoRoute(
    path: PersonalLoanSupportRouter.raise_new_ticket,
    builder: (context, state) => const PCRaiseNewTicketScreen(),
  ),
];
