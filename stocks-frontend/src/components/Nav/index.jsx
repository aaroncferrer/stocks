import { useState } from 'react';
import './nav.css'
import AuthModal from '../Modals/AuthModal';

function Nav({setCurrentUser}) {
    const [showLogin, setShowLogin] = useState(false);

    return (
        <nav className='topbar'>
            <AuthModal
                setCurrentUser={setCurrentUser}
                showLogin={showLogin}
                setShowLogin={setShowLogin}
            />

            <div className="nav_logo">
                <img src="./logo_colored.png" />
            </div>
            <div className="nav_actions">
                <a href="#">About</a>
                <a href="#">Blogs</a>
                <a href="#">Careers</a>
                <a href="#">Contact</a>
                <button className='btns btn_secondary' onClick={() => setShowLogin(true)}>
                    Sign In
                </button>
            </div>
        </nav>
    )
}

export default Nav;