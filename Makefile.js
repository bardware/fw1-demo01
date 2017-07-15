require( 'shelljs/make' );

const glob = require( 'glob' ),
	forEach = require( 'async-foreach' ).forEach,
	fs = require( 'fs' ),
	path = require( 'path' ),
	nodeCLI = require( 'shelljs-nodecli' );

var ansiColors = {
		//  'black': 30, 'yellow': 33, 'blue': 34, 'magenta': 35, 'white': 37
		red : 31,
		green : 32,
		cyan : 36
	},
	color = function( color, str ) {
		if( !color ) {
			return str;
		}
		return '\033[' + ansiColors[ color ] + 'm' + str + '\033[0m';
	};

function create( type, ttf, fontName, strFolderIn, strFolderOut ) {
	var command,
		strTargetFile = '';

	switch ( type ) {
		case 'woff':
			command = __dirname + '/dev/tools/woff-code-latest/sfnt2woff ' + ttf;
			strTargetFile = strFolderIn + '/' + fontName + '.woff';
			break;
		case 'woff2':
			command = __dirname + '/dev/tools/woff2/woff2_compress ' + ttf;
			strTargetFile = strFolderIn + '/' + fontName + '.woff2';
			break;
		default:
			console.error( color( 'red', 'type [svg|eot|woff] argument required' ) );
	}
	exec( command, function( err ) {
		if( err ) {
			console.error( '\033[31m%s\033[0m', type + ' error: ' + err );
		} else {
			console.log( color( 'green', 'Created ' + strFolderOut + '/' + fontName + '.' + type ) );
			mv( '-f', strTargetFile, strFolderOut + '/' );
		}
	} );
}

target.OpenSans2woff = function() {
	var strFolderIn = 'dev/vendor/opensans',
		strFolderOut = 'web/assets/fonts/OpenSans';

	fs.readdir( strFolderIn, function( err, fonts ) {
		var ttfs = [];

		if( err ) {
			throw err;
		}
		fonts.forEach( function( font ) {
			if( font.indexOf( '.ttf' ) > -1 ) {
				ttfs.push( font );
				console.log( 'Found   ' + strFolderIn + '/' + font );
			}
		} );
		if( ttfs.length ) {
			ttfs.forEach( function( font ) {
				var ttf = strFolderIn + '/' + font,
					fontName = font.split( '.' )[ 0 ];

				if( strFolderIn !== strFolderOut ) {
					mkdir( '-p', strFolderOut );
					create( 'woff', ttf, fontName, strFolderIn, strFolderOut );
					create( 'woff2', ttf, fontName, strFolderIn, strFolderOut );
				} else {
					create( 'woff', ttf, fontName, strFolderIn, strFolderOut );
					create( 'woff2', ttf, fontName, strFolderIn, strFolderOut );
				}
			} );
		} else {
			console.error( color( 'red', 'No TrueType fonts found in ' + strFolderIn ) );
		}
	} );
};
