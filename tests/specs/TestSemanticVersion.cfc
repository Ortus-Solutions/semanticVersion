component name="TestPrint" extends="testbox.system.compat.framework.TestCase" {

	public void function testDefaultVersion() {
		var semver = new models.semanticVersion();
		var defaultVersion = semver.getDefaultsVersion();
		assertEquals( defaultVersion, { major = 1, minor = 0, revision = 0, preReleaseID = "", buildID = 0 } );
	}

	public void function testClean() {
		var semver = new models.semanticVersion();
		assertEquals( semver.clean( '1.0.0' ), '1.0.0' );
		assertEquals( semver.clean( 'v1.0.0' ), '1.0.0' );
		assertEquals( semver.clean( '=1.0.0' ), '1.0.0' );
		assertEquals( semver.clean( '  =v1.2.3   ' ), '1.2.3' );
	}

	public void function testParseVersionAsString() {
		var semver = new models.semanticVersion();
		assertEquals( semver.parseVersionAsString( '1.0.0' ), '1.0.0' );
		assertEquals( semver.parseVersionAsString( '1.0.0+123' ), '1.0.0+123' );
		assertEquals( semver.parseVersionAsString( '1.0.0-alpha+123' ), '1.0.0-alpha+123' );
		assertEquals( semver.parseVersionAsString( '1' ), '1.0.0' );
	}

	public void function testIsPreRelease() {
		var semver = new models.semanticVersion();
		assertFalse( semver.isPreRelease( '1.0.0' ) );
		assertTrue( semver.isPreRelease( '1.0.0-alpha' ) );
	}

	public void function testIsEQ() {
		var semver = new models.semanticVersion();
		assertTrue( semver.isEQ( '1.0.0', '1.0.0' ) );
		assertTrue( semver.isEQ( '1', '1.0.0+0' ) );
		assertTrue( semver.isEQ( '1.0', '1.0.0+0' ) );
		assertTrue( semver.isEQ( '1.0.0', '1.0.0+0' ) );
		assertTrue( semver.isEQ( '1.2.3', '01.02.03' ) );
		assertFalse( semver.isEQ( '1.0.0', '1.0.0-f+0' ) );
		assertFalse( semver.isEQ( '1.0.0', '2.0.0' ) );
	}

	public void function testIsExactVersion() {
		var semver = new models.semanticVersion();
		assertFalse( semver.isExactVersion( '3' ) );
		assertFalse( semver.isExactVersion( '3.4' ) );
		assertTrue( semver.isExactVersion( '1.0.0' ) );
		assertTrue( semver.isExactVersion( '1.0.0-alpha' ) );
		assertTrue( semver.isExactVersion( '1.0.0+123' ) );
		assertTrue( semver.isExactVersion( '1.0.0-alpha+123' ) );
		assertFalse( semver.isExactVersion( '*' ) );
		assertFalse( semver.isExactVersion( '^2.2.1' ) );
		assertFalse( semver.isExactVersion( '~2.2.0' ) );
		assertFalse( semver.isExactVersion( '>2.1' ) );
		assertFalse( semver.isExactVersion( '1.0.0 - 1.2.0' ) );
		assertFalse( semver.isExactVersion( '>1.0.0-alpha' ) );
		assertFalse( semver.isExactVersion( '>=1.0.0-rc.0 <1.0.1' ) );
		assertFalse( semver.isExactVersion( '^2 <2.2 || > 2.3' ) );
		assertTrue( semver.isExactVersion( '1.2.3+123', true ) );
		assertFalse( semver.isExactVersion( '1.2.3', true ) );
	}

	public void function testIsNew() {
		var semver = new models.semanticVersion();
		assertTrue( semver.isNew( '1.0.0', '2.0.0' ) );
		assertTrue( semver.isNew( '1', '2' ) );
		assertTrue( semver.isNew( '1.0.0', '1.1.0' ) );
		assertTrue( semver.isNew( '1.0.0', '1.0.1' ) );
		assertTrue( semver.isNew( '1.0.0-alpha', '1.0.0' ) );
		assertTrue( semver.isNew( '1.0.0-alpha', '1.0.0-alpha.1' ) );
		assertTrue( semver.isNew( '1.0.0-alpha.1', '1.0.0-alpha.2' ) );
		assertFalse( semver.isNew( '1.0.0-alpha.10', '1.0.0-alpha.2' ) );
		assertTrue( semver.isNew( '1.0.0-alpha', '1.0.0-beta' ) );
		assertFalse( semver.isNew( '1.0.0-alpha.1', '1.0.0-alpha' ) );
		assertFalse( semver.isNew( '1.0.0-alpha.1.charlie', '1.0.0-alpha.1.beta' ) );
		assertTrue( semver.isNew( '1.0.0+0', '1.0.0+1' ) );
		assertTrue( semver.isNew( '1.0.0+123', '1.0.0+124' ) );
		assertFalse( semver.isNew( '1.0.0+0', '1.0.0+1', false ) );


		assertFalse( semver.isNew( '2.0.0', '1.0.0' ) );
		assertFalse( semver.isNew( '2', '1' ) );
		assertFalse( semver.isNew( '1.1.0', '1.0.0' ) );
		assertFalse( semver.isNew( '1.0.1', '1.0.0' ) );
		assertFalse( semver.isNew( '1.0.0', '1.0.0-alpha' ) );
		assertFalse( semver.isNew( '1.0.0-alpha.1', '1.0.0-alpha' ) );
		assertFalse( semver.isNew( '1.0.0-alpha.2', '1.0.0-alpha.1' ) );
		assertFalse( semver.isNew( '1.0.0-beta', '1.0.0-alpha' ) );
		assertFalse( semver.isNew( '1.0.0+1', '1.0.0+0' ) );
		assertFalse( semver.isNew( '1.0.0+124', '1.0.0+123' ) );
		assertFalse( semver.isNew( '1.0.0+1', '1.0.0+0', false ) );
	}

	public void function testCompare() {
		var semver = new models.semanticVersion();
        assertEquals( semver.compare( '1.0.0', '2.0.0' ), -1 );
		assertEquals( semver.compare( '1', '2' ), -1 );
		assertEquals( semver.compare( '1.0.0', '1.1.0' ), -1 );
		assertEquals( semver.compare( '1.0.0', '1.0.1' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha', '1.0.0' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha', '1.0.0-alpha.1' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha.1', '1.0.0-alpha' ), 1 );
		assertEquals( semver.compare( '1.0.0-alpha.1', '1.0.0-alpha.2' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha.9', '1.0.0-alpha.10' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha.10', '1.0.0-alpha.9' ), 1 );
		assertEquals( semver.compare( '1.0.0-alpha.9', '1.0.0-beta.2' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha', '1.0.0-beta' ), -1 );
		assertEquals( semver.compare( '1.0.0+0', '1.0.0+1' ), -1 );
		assertEquals( semver.compare( '1.0.0+123', '1.0.0+124' ), -1 );
		assertEquals( semver.compare( '1.0.0+0', '1.0.0+1', false ), 0 );

		assertEquals( semver.compare( '2.0.0', '1.0.0' ), 1 );
		assertEquals( semver.compare( '2', '1' ), 1 );
		assertEquals( semver.compare( '1.1.0', '1.0.0' ), 1 );
		assertEquals( semver.compare( '1.0.1', '1.0.0' ), 1 );
		assertEquals( semver.compare( '1.0.0', '1.0.0-alpha' ), 1 );
		assertEquals( semver.compare( '1.0.0-alpha.1', '1.0.0-alpha' ), 1 );
		assertEquals( semver.compare( '1.0.0-alpha.2', '1.0.0-alpha.1' ), 1 );
		assertEquals( semver.compare( '1.0.0-beta', '1.0.0-alpha' ), 1 );
		assertEquals( semver.compare( '1.0.0+1', '1.0.0+0' ), 1 );
		assertEquals( semver.compare( '1.0.0+124', '1.0.0+123' ), 1 );
		assertEquals( semver.compare( '1.0.0+1', '1.0.0+0', false ), 0 );

		assertEquals( semver.compare( '', '' ), 0 );
		assertEquals( semver.compare( '1.0.0', '1.0.0' ), 0 );
		assertEquals( semver.compare( '1', '1.0.0+0' ), 0 );
		assertEquals( semver.compare( '1.0', '1.0.0+0' ), 0 );
        assertEquals( semver.compare( '1.0.0', '1.0.0+0' ), 0 );

		assertEquals( semver.compare( '1.0.0-alpha.9', '1.0.0-alpha.beta' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha.9', '1.0.0-alpha.9.beta' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha.9.beta', '1.0.0-alpha.9.charlie' ), -1 );
		assertEquals( semver.compare( '1.0.0-alpha.9.beta.5', '1.0.0-alpha.9.beta.20' ), -1 );
	}

	public void function testSatisfies() {
		var semver = new models.semanticVersion();

		assertTrue( semver.satisfies( '1.0.0', '1.0.0+0' ) );
		assertTrue( semver.satisfies( '1.2.3', '1.x || >=2.5.0 || 5.0.0 - 7.2.3' ) );
		assertTrue( semver.satisfies( '1.0.0', '<2.0.0' ) );
		assertTrue( semver.satisfies( '0.5', '<1.0.0' ) );
		assertFalse( semver.satisfies( '1.0.0', '<1.0.0' ) );

		assertTrue( semver.satisfies( '2.0.0', '>1.0.0' ) );
		assertFalse( semver.satisfies( '1.0.0', '>1.0.0' ) );

		assertTrue( semver.satisfies( '1.0.0', '>=1.0.0' ) );
		assertTrue( semver.satisfies( '2.0.0', '>=1.0.0' ) );

		assertTrue( semver.satisfies( '2.0.0', '<=2.0.0' ) );
		assertTrue( semver.satisfies( '1.0.0', '<=2.0.0' ) );

		assertTrue( semver.satisfies( '1.0.0', '1.0.0' ) );
		assertTrue( semver.satisfies( '1.0.0', 'v1.0.0' ) );
		assertTrue( semver.satisfies( 'v1.0.0', '1.0.0' ) );
		assertTrue( semver.satisfies( 'v1.0.0', 'v1.0.0' ) );
		assertTrue( semver.satisfies( '1.0.0', '=1.0.0' ) );

		assertTrue( semver.satisfies( '1.5.0', '>1.0.0 <2.0.0' ) );
		assertFalse( semver.satisfies( '1.0.0', '>1.0.0 <2.0.0' ) );
		assertFalse( semver.satisfies( '2.0.0', '>1.0.0 <2.0.0' ) );
		assertFalse( semver.satisfies( '2.5.0', '>1.0.0 <2.0.0' ) );
		assertFalse( semver.satisfies( '1.0.0', '>2.0.0 <3.0.0' ) );

		assertTrue( semver.satisfies( '1.0.0', '>=1.0.0 <=2.0.0' ) );
		assertTrue( semver.satisfies( '2.0.0', '>=1.0.0 <=2.0.0' ) );;

		assertTrue( semver.satisfies( '1.0.0', '1.0.0 || 2.0.0' ) );
		assertTrue( semver.satisfies( '2.0.0', '1.0.0 || 2.0.0' ) );
		assertFalse( semver.satisfies( '3.0.0', '1.0.0 || 2.0.0' ) );

		assertTrue( semver.satisfies( '1.0.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertTrue( semver.satisfies( '1.1.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertTrue( semver.satisfies( '1.2.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertTrue( semver.satisfies( '1.5.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertTrue( semver.satisfies( '2.0.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertTrue( semver.satisfies( '2.1.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertTrue( semver.satisfies( '2.5.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );

		assertFalse( semver.satisfies( '0.9.9', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertFalse( semver.satisfies( '1.6.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertFalse( semver.satisfies( '1.9.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );
		assertFalse( semver.satisfies( '2.6.0', '>=1.0.0 <=1.5.0 || >=2.0.0 <=2.5.0' ) );

		assertTrue( semver.satisfies( '1.0.0', '' ) );
		assertTrue( semver.satisfies( '1.0.0', '*' ) );
		assertTrue( semver.satisfies( '1.0.0', 'x' ) );

		assertTrue( semver.satisfies( '0.5', '0.x' ) );
		assertTrue( semver.satisfies( '1.0.0', '1.x' ) );
		assertTrue( semver.satisfies( '1.5.0', '1.x' ) );
		assertTrue( semver.satisfies( '1.9.0', '1.x' ) );
		assertFalse( semver.satisfies( '0.9.0', '1.x' ) );
		assertFalse( semver.satisfies( '2.0.0', '1.x' ) );

		assertTrue( semver.satisfies( '1.0.0', '1.0.x' ) );
		assertTrue( semver.satisfies( '1.0.1', '1.0.x' ) );
		assertTrue( semver.satisfies( '1.0.9', '1.0.x' ) );
		assertFalse( semver.satisfies( '0.9.9', '1.0.x' ) );
		assertFalse( semver.satisfies( '1.1.0', '1.0.x' ) );

		assertTrue( semver.satisfies( '1.0.0', '<2.0.x' ) );
		assertTrue( semver.satisfies( '1.9.9', '<2.0.x' ) );
		assertFalse( semver.satisfies( '2.0.0', '<2.0.x' ) );
		assertFalse( semver.satisfies( '2.1.0', '<2.0.x' ) );

		assertTrue( semver.satisfies( '2.0.0', '<=2.0.x' ) );
		assertTrue( semver.satisfies( '2.0.1', '<=2.0.x' ) );
		assertTrue( semver.satisfies( '2.0.9', '<=2.0.x' ) );
		assertFalse( semver.satisfies( '2.1.0', '<=2.0.x' ) );

		assertTrue( semver.satisfies( '2.0.0', '<=2.x' ) );
		assertTrue( semver.satisfies( '2.9.0', '<=2.x' ) );
		assertTrue( semver.satisfies( '2.9.9', '<=2.x' ) );
		assertFalse( semver.satisfies( '3.0.0', '<=2.x' ) );

		assertTrue( semver.satisfies( '3.0.0', '>2.x' ) );
		assertFalse( semver.satisfies( '2.1.0', '>2.x' ) );

		assertTrue( semver.satisfies( '2.1.0', '>2.0.x' ) );
		assertFalse( semver.satisfies( '2.0.1', '>2.0.x' ) );

		assertTrue( semver.satisfies( '2.0.0', '>=2.x' ) );
		assertFalse( semver.satisfies( '1.9.0', '>=2.x' ) );

		assertTrue( semver.satisfies( '2.1.0', '>=2.1.x' ) );
		assertFalse( semver.satisfies( '2.0.9', '>=2.1.x' ) );

		assertTrue( semver.satisfies( '1.2.3-alpha.7', '>1.2.3-alpha.3' ) );
		assertFalse( semver.satisfies( '3.4.5-alpha.9', '>1.2.3-alpha.3' ) );
		assertTrue( semver.satisfies( '5.3.9-SNAPSHOT', '5.3.9-SNAPSHOT' ) );
		assertTrue( semver.satisfies( '5.3.9-SNAPSHOT', '5.x.x-SNAPSHOT' ) );
		assertTrue( semver.satisfies( '5.3.9-SNAPSHOT', '5-SNAPSHOT' ) );
		assertTrue( semver.satisfies( '5.3.9-SNAPSHOT', '5-alpha' ) );
		assertFalse( semver.satisfies( '5.3.9-rc.1', '5.3.9-rc.2' ) );
		assertTrue( semver.satisfies( '5.3.9-rc.1', '5-rc.2' ) );
		assertTrue( semver.satisfies( '5.3.9', '5-rc.2' ) );
		assertTrue( semver.satisfies( '5.4.0', '>5.3.9-rc.2' ) );

		assertTrue( semver.satisfies( '1.2.3', '~1.2.3' ) );
		assertTrue( semver.satisfies( '1.2.9', '~1.2.3' ) );
		assertFalse( semver.satisfies( '1.3.0', '~1.2.3' ) );

		assertTrue( semver.satisfies( '0.2.3', '~0.2.3' ) );
		assertTrue( semver.satisfies( '0.2.9', '~0.2.3' ) );
		assertFalse( semver.satisfies( '0.3.0', '~0.2.3' ) );

		assertTrue( semver.satisfies( '1.2.0', '~1.2' ) );
		assertTrue( semver.satisfies( '1.5.0', '~1' ) );
		assertTrue( semver.satisfies( '0.2.5', '~0.2' ) );
		assertTrue( semver.satisfies( '0.5.0', '~0' ) );

		assertTrue( semver.satisfies( '1.2.3-beta.2', '~1.2.3-beta.2' ) );
		assertTrue( semver.satisfies( '1.2.3-beta.3', '~1.2.3-beta.2' ) );
		assertTrue( semver.satisfies( '1.2.3', '~1.2.3-beta.2' ) );
		assertTrue( semver.satisfies( '1.2.4', '~1.2.3-beta.2' ) );
		assertFalse( semver.satisfies( '1.2.4-beta.2', '~1.2.3-beta.2' ) );


		assertTrue( semver.satisfies( '2.0.0', '1.2.3 - 2.3.4' ) );
		assertTrue( semver.satisfies( '1.2.3', '1.2.3 - 2.3.4' ) );
		assertTrue( semver.satisfies( '2.3.4', '1.2.3 - 2.3.4' ) );
		assertFalse( semver.satisfies( '1.2.2', '1.2.3 - 2.3.4' ) );
		assertFalse( semver.satisfies( '2.3.5', '1.2.3 - 2.3.4' ) );

		assertTrue( semver.satisfies( '2.0.0', '1.2 - 2.3.4' ) );
		assertTrue( semver.satisfies( '1.2.0', '1.2 - 2.3.4' ) );

		assertTrue( semver.satisfies( '2.3.9', '1.2.3 - 2.3' ) );
		assertFalse( semver.satisfies( '2.4.0', '1.2.3 - 2.3' ) );

		assertTrue( semver.satisfies( '1.9.9', '^1.2.3' ) );
		assertTrue( semver.satisfies( '0.2.4', '^0.2.3' ) );
		assertTrue( semver.satisfies( '0.0.3', '^0.0.3' ) );
		assertTrue( semver.satisfies( '1.5.0', '^1.2.3-beta.2' ) );
		assertTrue( semver.satisfies( '1.9.9', '^1.2.x' ) );
		assertTrue( semver.satisfies( '0.0.1', '^0.0.x' ) );
		assertTrue( semver.satisfies( '0.0.1', '^0.0' ) );
		assertTrue( semver.satisfies( '1.5.0', '^1.x' ) );
		assertTrue( semver.satisfies( '0.5.0', '^0.x' ) );

		// test invalid semvers just to make sure they don't error
		assertfalse( semver.satisfies( '1.2.3', 'foo' ) );
		assertfalse( semver.satisfies( '1.2.3', 'foo.bar' ) );
		assertfalse( semver.satisfies( '1.2.3', 'foo.bar.baz' ) );

		assertTrue( semver.satisfies('1.2.3', '1.x || >=2.5.0 || 5.0.0 - 7.2.3') );

		assertTrue( semver.satisfies('1.2.3', 'be') );
		assertTrue( semver.satisfies('1.2.3', 'stable') );
		assertFalse( semver.satisfies('1.2.3-alpha', 'stable') );

	}

	public void function testComparator() {
		var semver = new models.semanticVersion();

		makepublic( semver, 'evaluateComparator' );

		// Passing an invalid operator should return false.
		assertfalse( semver.evaluateComparator( { 'operator' : 'foobar' }, '' ) );
	}

}
