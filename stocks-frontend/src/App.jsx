// Bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';

// File Imports
import Landing from "./pages/Landing"
import AdminDashboard from "./pages/AdminDashboard"
import TraderDashboard from "./pages/TraderDashboard"
import Footer from './components/Footer';

import { useEffect, useState } from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

function App() {
    const [currentUser, setCurrentUser] = useState(JSON.parse(localStorage.getItem('currentUser')) || null)
    
    const apiUrl = import.meta.env.VITE_REACT_APP_API_URL;
    console.log(apiUrl);    

    useEffect(() => {
        localStorage.setItem('currentUser', JSON.stringify(currentUser))
    }, [currentUser])

    return (
        <Router>  
            <Routes>
                <Route exact path='/' element={<Landing 
                    setCurrentUser={setCurrentUser} />} 
                />
                <Route exact path='/admin' element={<AdminDashboard 
                    currentUser={currentUser} />} 
                />
                <Route exact path='/trader' element={<TraderDashboard 
                    currentUser={currentUser} 
                    setCurrentUser={setCurrentUser} />} 
                />
            </Routes>
            <Footer />
        </Router>
    )
}

export default App
