import 'package:challenge_seekpania/page/header.dart';
import 'package:challenge_seekpania/widget/create_account.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Terms and Conditions"),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Welcome to Seekpania!',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'These terms and conditions outline the rules and regulations for the use of Seekpania\'s mobile app.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this website and compliant to the Company\'s terms and conditions. "The Company", "Ourselves", "We", "Our" and "Us", refers to our Company/ "Party", "Parties", or "Us", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client\'s needs in respect of provision of the Company\'s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Cookies',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'We employ the use of cookies. By accessing Seekpania, you agreed to use cookies in agreement with the Seekpania\'s Privacy Policy.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Most interactive websites use cookies to let us retrieve the user’s details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'License',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Unless otherwise stated, Seekpania and/or its licensors own the intellectual property rights for all material on Seekpania. All intellectual property rights are reserved. You may access this from Seekpania for your own personal use subjected to restrictions set in these terms and conditions.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'You must not.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Republish material from Seekpania',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Sell, rent or sub-license material from Seekpania',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Reproduce, duplicate or copy material from Seekpania',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Redistribute content from Seekpania',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'This Agreement shall begin on the date hereof. Our Terms and Conditions were created with the help of the Terms And Conditions Generator and the Privacy Policy Generator..',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Seekpania does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Seekpania,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Seekpania shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Seekpania reserves the right to monitor all Messages and to remove any Messages which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'You warrant and represent that:',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'The Messages do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'The Messages will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'You hereby grant Seekpania a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Hyperlinking to our Content',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'The following organizations may link to our Website without prior written approval:',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Government agencies;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Search engines;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'News organizations;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'We may consider and approve other link requests from the following types of organizations:',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'commonly-known consumer and/or business information sources;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'dot.com community sites;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'associations or other groups representing charities;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'online directory distributors;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'internet portals;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'accounting, law and consulting firms; and',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'educational institutions and trade associations.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Seekpania; and (d) the link is in the context of general resource information.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'These organizations may link to our home page so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party’s site..',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'If you are one of the organizations listed in paragraph 2 above and are interested in linking to our website, you must inform us by sending an e-mail to Seekpania. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our Website, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response..',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Approved organizations may hyperlink to our Website as follows:',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'By use of our corporate name; or',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'By use of the uniform resource locator being linked to; or',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'By use of any other description of our Website being linked to that makes sense within the context and format of content on the linking party’s site.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'No use of Seekpania\'s logo or other artwork will be allowed for linking absent a trademark license agreement.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Content Liability',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'We shall not be hold responsible for any content that appears on your Website. You agree to protect and defend us against all claims that is rising on your Website. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Your Privacy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'Please read Privacy Policy',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 45.0, right: 10.0),
            child: Text(
              'Reservation of Rights',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'We reserve the right to request that you remove all links or any particular link to our Website. You approve to immediately remove all links to our Website upon request. We also reserve the right to amen these terms and conditions and it’s linking policy at any time. By continuously linking to our Website, you agree to be bound to and follow these linking terms and conditions.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Removal of links from our website',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'If you find any link on our Website that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0),
            child: Text(
              'Disclaimer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our website and the use of this website. Nothing in this disclaimer will:',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'limit or exclude our or your liability for death or personal injury;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'limit or exclude our or your liability for fraud or fraudulent misrepresentation;',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'limit any of our or your liabilities in any way that is not permitted under applicable law; or',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'exclude any of our or your liabilities that may not be excluded under applicable law.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0),
            child: Text(
              'The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
            child: Text(
              'As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.',
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => CreateAccount()));
              },
              child: Container(
                width: 130.0,
                height: 40.0,
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: Colors.deepPurple,
                  ),
                  color: Colors.deepPurple,
                  // shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'I AGREE',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
