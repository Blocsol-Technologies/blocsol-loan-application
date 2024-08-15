import 'package:blocsol_loan_application/invoice_loan/screens/protected/support/raise_ticket.dart';
import 'package:blocsol_loan_application/invoice_loan/screens/protected/support/single_ticket_details.dart';
import 'package:go_router/go_router.dart';

class InvoiceLoanSupportRouter {
  static const raise_new_ticket = "/invoice-loan/support/raise-new-ticket";
  static const view_ticket = "/invoice-loan/support/view-ticket";
}

List<GoRoute> invoiceLoanSupportRoutes = [
  GoRoute(
    path: InvoiceLoanSupportRouter.raise_new_ticket,
    builder: (context, state) => const InvoiceLoanRaiseNewTicket(),
  ),
  GoRoute(
    path: InvoiceLoanSupportRouter.view_ticket,
    builder: (context, state) => const InvoiceLoanSingleTicketDetails(),
  ),
];
