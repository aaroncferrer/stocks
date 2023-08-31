// Bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';

import Landing from "./pages/Landing"
import { useEffect, useState } from 'react';
import Nav from './components/Nav';
import Footer from './components/Footer';

function App() {
    const [currentUser, setCurrentUser] = useState(JSON.parse(localStorage.getItem('currentUser')) || null)

    useEffect(() => {
        localStorage.setItem('currentUser', JSON.stringify(currentUser))
    }, [currentUser])

    return (
        <>  
            <Nav setCurrentUser={setCurrentUser} />
            <Landing />
            <Footer />
        </>
    )
}

export default App
