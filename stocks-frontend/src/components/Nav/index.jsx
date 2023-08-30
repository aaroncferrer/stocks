import './nav.css'

function Nav() {
    return (
        <nav>
            <div className="nav_logo">
                <img src="./logo_colored.png" />
            </div>
            <div className="nav_actions">
                <a href="#">About</a>
                <a href="#">Reviews</a>
                <a href="#">Contact</a>
                <button className='btns btn_primary'>Sign In</button>
            </div>
        </nav>
    )
}

export default Nav;